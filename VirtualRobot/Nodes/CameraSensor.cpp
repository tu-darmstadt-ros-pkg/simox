
#include "CameraSensor.h"

using namespace boost;

namespace VirtualRobot {

CameraSensor::CameraSensor(	RobotNodeWeakPtr robotNode, 
				const std::string &name,
				VisualizationNodePtr visualization,
				const Eigen::Matrix4f &rnTrafo 
				) : Sensor(robotNode,name,visualization,rnTrafo)
{

}


CameraSensor::~CameraSensor()
{
}



void CameraSensor::print( bool printChildren, bool printDecoration ) const
{
	if (printDecoration)
		cout << "******** CameraSensor ********" << endl;
	Sensor::print(printChildren,false);
}


SensorPtr CameraSensor::_clone(const RobotNodePtr newRobotNode, const VisualizationNodePtr visualizationModel, float scaling)
{
	THROW_VR_EXCEPTION_IF(scaling<0,"Scaling must be >0");
	Eigen::Matrix4f rnt = rnTransformation;
	rnt.block(0,3,3,1) *= scaling;
	SensorPtr result(new CameraSensor(newRobotNode,name,visualizationModel,rnt));
	return result;
}

} // namespace VirtualRobot
